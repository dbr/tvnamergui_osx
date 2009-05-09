#import "tvdb_api_wrapper.h"
#import <Python/Python.h>

@implementation tvdb_api_wrapper

-(PyObject*)importModule:(NSString*)name
{
    PyObject *module = PyImport_Import(PyString_FromString([name UTF8String]));
    return module;
}

-(PyObject*)callMethod:(NSString*)method
            fromModule:(PyObject*)module
              withArgs:(NSArray*)args
{
    PyObject *thefunc = PyObject_GetAttrString(module, [method UTF8String]);
    NSInteger num_args = [args count];
    PyObject *arg_tuple = PyTuple_New(num_args);
    for(NSInteger i = 0; i < num_args; i++)
    {
        NSString *cur_arg = (NSString*)[args objectAtIndex:i];
        PyTuple_SetItem(arg_tuple, i, PyString_FromString([cur_arg UTF8String]));
    }
    
    PyObject *result = PyObject_CallObject(thefunc, arg_tuple);
    return result;
}

-(NSMutableDictionary*)pyDictToNSDict:(PyObject*)thePyDict
{
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

-(NSNumber*)getSeriesId:(NSString*)seriesName
{
    PyObject *module = [self importModule:@"tvdb_api"];
    PyObject *tvdb_api = PyObject_GetAttrString(module, "Tvdb");
    PyObject *tvdb = PyInstance_New(tvdb_api, nil, nil);
    PyObject *py_showinfo = [self callMethod:@"_getSeries"
                                  fromModule:tvdb
                                    withArgs:[NSArray arrayWithObjects:@"scrubs", nil]];
    NSMutableDictionary *showinfo = [self pyDictToNSDict:py_showinfo];
    NSLog(@"%@", showinfo);
    return [showinfo objectForKey:@"sid"];
}

-(NSString*)getEpisodeNameForSeries:(NSString*)seriesName
                             seasno:(NSNumber*)seasno
                               epno:(NSNumber*)epno
{
    Py_Initialize();
    NSNumber *sid = [self getSeriesId:seriesName];
    NSLog(@"Got series ID of %@", sid);
    Py_Finalize();
    return [NSString string];
}

@end
