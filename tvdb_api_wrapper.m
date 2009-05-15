#import "tvdb_api_wrapper.h"
#import <Python/Python.h>

@implementation tvdb_api_wrapper

-(PyObject*)importModule:(NSString*)name
{
    /* Imports a Python module
     */
    PyObject *module = PyImport_Import(PyString_FromString([name UTF8String]));
    return module;
}

-(PyObject*)callMethod:(NSString*)method
            fromModule:(PyObject*)module
              withArgs:(NSArray*)args
{
    /* Takes a method (from importModule) and calls a method on it,
     * takes an array with arguments
     */
    PyObject *thefunc = PyObject_GetAttrString(module, [method UTF8String]);
    NSInteger num_args = [args count];
    PyObject *arg_tuple = PyTuple_New(num_args);
    
    for(NSInteger i = 0; i < num_args; i++)
    {
        id cur_arg = [args objectAtIndex:i];
        PyObject *cur_arg_cast;
        if( [cur_arg isKindOfClass:[NSString class]] ){
            cur_arg_cast = PyString_FromString([cur_arg UTF8String]);
        }
        else if([cur_arg isKindOfClass:[NSNumber class]])
        {
            cur_arg_cast = PyInt_FromLong([cur_arg longValue]);
        }
        else
        {
            NSLog(@"WARNING: Unknown arg (type %@), casting to string", [cur_arg class]);
            cur_arg_cast = PyString_FromString([(NSString*)cur_arg UTF8String]);
        }
        PyTuple_SetItem(arg_tuple, i, cur_arg_cast);
    }
    
    PyObject *result = PyObject_CallObject(thefunc, arg_tuple);
    return result;
}

-(NSMutableDictionary*)pyDictToNSDict:(PyObject*)thePyDict
{
    /* Takes a PyObject dictionary, turns it into a NSMutableDictionary.
     * Currently only handles str/unicode/integer data-types
     */
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    
    PyObject *cur_key, *cur_value;
    Py_ssize_t pos = 0;
    
    while(PyDict_Next(thePyDict, &pos, &cur_key, &cur_value)){
        NSString *key = [NSString stringWithUTF8String:PyString_AsString(cur_key)];
        id value;
        if(PyString_Check(cur_value) || PyUnicode_Check(cur_value)){
            value = [NSString stringWithUTF8String:PyString_AsString(cur_value)];    
        }
        else if(PyInt_Check(cur_value))
        {
            value = [NSNumber numberWithLong:PyInt_AsLong(cur_value)];
        }
        else if(PyLong_Check(cur_value))
        {
            value = [NSNumber numberWithLong:PyLong_AsLong(cur_value)];
        }
        else
        {
            NSLog(@"WARNING: value for %@ was not string or integer, using repr()", key);
            value = [NSString stringWithUTF8String:
                     PyString_AsString(PyObject_Repr(cur_value))];
        }
        
        [ret setObject:value forKey:key];
    }
    return ret;
}


/* Public'ish  methods */

-(NSMutableDictionary*)getSeriesId:(NSString*)seriesName
{
    /* Takes a series name, returns the series ID and name in dictionary */
    Py_Initialize();
    PyObject *module = [self importModule:@"tvdb_api"];
    PyObject *tvdb_api = PyObject_GetAttrString(module, "Tvdb");
    PyObject *tvdb = PyInstance_New(tvdb_api, nil, nil);
    PyObject *py_showinfo = [self callMethod:@"_getSeries"
                                  fromModule:tvdb
                                    withArgs:[NSArray arrayWithObject:seriesName]];
    
    NSMutableDictionary *showinfo = [self pyDictToNSDict:py_showinfo];
    Py_Finalize();
    return showinfo;
}

-(NSMutableDictionary*)parseName:(NSString*)name
{
    Py_Initialize();
    PyObject *module = [self importModule:@"tvnamer"];
    PyObject *valid_name = [self callMethod:@"processSingleName"
                                 fromModule:module
                                   withArgs:[NSArray arrayWithObjects:name, nil]];
    if(valid_name == Py_None){
        NSLog(@"Not found!");
        return nil;
    }
    
    NSMutableDictionary *ret = [self pyDictToNSDict:valid_name];
    
    Py_Finalize();
    return ret;
}

-(NSString*)getEpNameForSid:(NSNumber*)sid
                     seasno:(NSNumber*)seasno
                       epno:(NSNumber*)epno
{
    Py_Initialize();
    NSLog(@"Getting ep name for %@ - %@x%@", sid, seasno, epno);
    PyObject *module = [self importModule:@"tvdb_api"];
    PyObject *tvdb_api = PyObject_GetAttrString(module, "Tvdb");
    PyObject *tvdb = PyInstance_New(tvdb_api, nil, nil);
    [self callMethod:@"_getShowData"
          fromModule:tvdb
            withArgs:[NSArray arrayWithObject:sid]];
    
    PyObject *show = [self callMethod:@"__getitem__"
          fromModule:tvdb
            withArgs:[NSArray arrayWithObject:sid]];
    
    PyObject *season = PyObject_GetItem(show, PyInt_FromLong([seasno longValue]));
    if(!season){
        Py_Finalize();
        NSLog(@"Panic, season is null");
        return nil;
    }
    
    PyObject *episode = PyObject_GetItem(season, PyInt_FromLong([epno longValue]));
    if(!episode){
        Py_Finalize();
        NSLog(@"Panic, episode is null");
        return nil;
    };
    
    PyObject *attr = PyObject_GetItem(episode, PyString_FromString("episodename"));
    if(!attr){
        Py_Finalize();
        NSLog(@"Panic, attr is null");
        return nil;
    }
    
    NSString *epname = [NSString stringWithUTF8String:PyString_AsString(attr)];

    Py_Finalize();
    return epname;
}

@end
